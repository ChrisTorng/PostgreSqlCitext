# PostgreSqlCitext

Simple test project for [EF Core Power Tools](https://github.com/ErikEJ/EFCorePowerTools) supporting PostgreSQL `citext` type.

## The Problems

I'm using 4/6/2026 2.6.1465 version of [EF Core Power Tools](https://marketplace.visualstudio.com/items?itemName=ErikEJ.EFCorePowerTools) to do Reverse Engineering.

For table with `citext` column, EFCPT supports are great.

There are four problems I'm facing:

1. For function with `citext` parameter, EFCPT can't generate codes.
2. For function with `citext` return value, EFCPT can't generate codes, with different error.
3. The generation stops without other normal ones generated, and not showing which item causes the problem.
4. The renaming of function returned table column doesn't work on Edit UI or on `efpt.renaming.json`.

### Problem 1: `citext` parameter in function

For a simple [`sql/testcitextin.sql`](sql/testcitextin.sql), using original EF Core Power Tools to refresh [`BeforeFix/efpt.testcitextin.config.json`](BeforeFix/efpt.testcitextin.config.json), it ends up this error message:
```
System.Exception: System.ArgumentOutOfRangeException: cleanedTypeName: USER-DEFINED (Parameter 'storeType')
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.GetNpgsqlDbType(String storeType) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 192
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.GetClrType(String storeType, Boolean isNullable, String objectName, Boolean asParameter) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 101
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.ClrTypeFromNpgsqlParameter(ModuleParameter storedProcedureParameter, Boolean asMethodParameter) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 82
   at RevEng.Core.Routines.Extensions.PostgresClrTypeMapper.GetClrType(ModuleParameter parameter) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresClrTypeMapper.cs:line 10
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.<>c__DisplayClass16_0.<CreateUsings>b__5(ModuleParameter p) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 197
   at System.Linq.Enumerable.Any[TSource](IEnumerable`1 source, Func`2 predicate)
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.CreateUsings(ModuleScaffolderOptions scaffolderOptions, RoutineModel model, List`1 schemas) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 197
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.WriteDbContextInterface(ModuleScaffolderOptions scaffolderOptions, RoutineModel model, List`1 schemas) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 226
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.ScaffoldModel(RoutineModel model, ModuleScaffolderOptions scaffolderOptions, List`1 schemas, List`1& errors) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 129
   at RevEng.Core.ReverseEngineerScaffolder.GenerateStoredProcedures(ReverseEngineerCommandOptions options, List`1 schemas, List`1& errors, String outputContextDir, String modelNamespace, String contextNamespace, Boolean supportsProcedures) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\ReverseEngineerScaffolder.cs:line 222
   at RevEng.Core.ReverseEngineerRunner.GenerateFiles(ReverseEngineerCommandOptions options) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\ReverseEngineerRunner.cs:line 107
```

### Problem 2: `citext` return value in function

For [`sql/testcitextout.sql`](sql/testcitextout.sql) with [`BeforeFix/efpt.testcitextout.config.json`](BeforeFix/efpt.testcitextout.config.json), it ends up this error message:
```
System.Exception: System.ArgumentOutOfRangeException: storetype: citext, objectName: testcitextout (Parameter 'storeType')
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.GetClrType(String storeType, Boolean isNullable, String objectName, Boolean asParameter) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 165
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.GetClrType(ModuleResultElement moduleResultElement) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 96
   at RevEng.Core.Routines.Extensions.PostgresClrTypeMapper.GetClrType(ModuleResultElement resultElement) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresClrTypeMapper.cs:line 15
   at RevEng.Core.Routines.Scaffolder.<WriteResultClass>b__4_0(ModuleResultElement p) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Scaffolder.cs:line 41
   at System.Collections.Generic.List`1.FindIndex(Int32 startIndex, Int32 count, Predicate`1 match)
   at System.Collections.Generic.List`1.Exists(Predicate`1 match)
   at RevEng.Core.Routines.Scaffolder.WriteResultClass(List`1 resultElements, ModuleScaffolderOptions options, String name, String schemaName) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Scaffolder.cs:line 41
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.ScaffoldModel(RoutineModel model, ModuleScaffolderOptions scaffolderOptions, List`1 schemas, List`1& errors) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 75
   at RevEng.Core.ReverseEngineerScaffolder.GenerateStoredProcedures(ReverseEngineerCommandOptions options, List`1 schemas, List`1& errors, String outputContextDir, String modelNamespace, String contextNamespace, Boolean supportsProcedures) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\ReverseEngineerScaffolder.cs:line 222
   at RevEng.Core.ReverseEngineerRunner.GenerateFiles(ReverseEngineerCommandOptions options) in D:\a\EFCorePowerTools\EFCorePowerTools\src\Core\RevEng.Core.80\ReverseEngineerRunner.cs:line 107
```

### Problem 3: Generate stops without showing which item causes the problem

For both cases, the generate stops, without anything like [`sql/testtext.sql`](sql/testtext.sql) related generated. You can check [`BeforeFix/TestCitextInModels/`](BeforeFix/TestCitextInModels/) and [`BeforeFix/TestCitextOutModels/`](BeforeFix/TestCitextOutModels/) folders for generated codes.

For [`sql/testcitextin.sql`](sql/testcitextin.sql) one, the error message doesn't shows which item causes this problem, makes it hard to find out the problematic item while there are lots of items.

But for [`sql/testtext.sql`](sql/testtext.sql) with [`BeforeFix/efpt.testtext.config.json`](BeforeFix/efpt.testtext.config.json), it generates codes in [`BeforeFix/TestTextModels/`](BeforeFix/TestTextModels/) successfully.

### Problem 4: The renaming of returned table column doesn't work

The Edit UI can only rename the function name `testtext` into `TestText`, not supporting the returned table's column names. Even with manual editing of [`BeforeFix/efpt.renaming.json`](BeforeFix/efpt.renaming.json) (it's easy now with the help of AI) to rename the returned table column, it doesn't work. You can check the generated code in [`BeforeFix/TestTextModels/TestTextResult.cs`](BeforeFix/TestTextModels/TestTextResult.cs). And the manual editing of [`BeforeFix/efpt.renaming.json`](BeforeFix/efpt.renaming.json) will be overridden by later Edit UI.

## The Fixes

I've forked [ErikEJ/EFCorePowerTools](https://github.com/ErikEJ/EFCorePowerTools) from [chore: move sln to slnx (#3343)](https://github.com/ErikEJ/EFCorePowerTools/commit/cfb4c2f99616d8e2886440d35555fa1b4c842457) into my repo [ChrisTorng/EFCorePowerTools](https://github.com/ChrisTorng/EFCorePowerTools). With the help of GitHub Copilot, I made some changes to make it works on my Visual Studio 2026 Insiders, easier to debug (cause I can't found other easier ways). And the fixes are these:

1. Problem 1/2 (`citext` in/out): [Fix citext in/out parameter code gen](https://github.com/ChrisTorng/EFCorePowerTools/commit/96a3ec6407b33766da612f1acba6aee945e8c5bf) and [Fix citext in/out parameter code genenation](https://github.com/ChrisTorng/EFCorePowerTools/commit/fde5123aa40cbf9a6144306502e725439da85015).
2. Problem 3 (generation stops without which): [Always generate code by pre-check, print error message and remove problematic items](https://github.com/ChrisTorng/EFCorePowerTools/commit/2ba803314e3b0adca9e5217777a1feec8ae1adda).
3. Problem 4 (renaming of returned table column): [Add Result class rename function](https://github.com/ChrisTorng/EFCorePowerTools/commit/ae83a5a1d8728a1baa59f731a7444f4171592904). But it only works on `Refresh`. The manual editing of [`AfterFix/efpt.renaming.json`](AfterFix/efpt.renaming.json) doesn't survive after Edit UI.

### The Results

The fixed version of EFCPT, Refreshing the [`AfterFix/efpt.config.json`](AfterFix/efpt.config.json), has one error message left:
```
Unable to scaffold "dbo"."testrefcursor": parameter 'p_refcur' has unsupported store type 'refcursor'. storetype: refcursor, objectName: p_refcur (Parameter 'storeType')
```

It clearly indicates the problematic item, without blocking others. (We are not willing to use `refcursor`, so it's not a blocking problem for us.)

And all other codes generated successfully, under [`AfterFix/Models/`](AfterFix/Models/) folders. Mainly in [`AfterFix/Models/TestTextResult.cs`](AfterFix/Models/PGContextFunctions.cs) with `testcitextinAsync()`/`testcitextoutAsync()`/`TestTextAsync()` generated. And the renaming result is in [`AfterFix/Models/TestTextResult.cs`](AfterFix/Models/TestTextResult.cs). The column name is now `ResultColumn` with `[Column("resultcolumn")]` attribute, instead of `resultcolumn`.

## No PR for original repo

Sorry it's hard for me to contribute a PR to the original repo, because of:

1. These changes are made by GitHub Copilot mainly. I can understand some easier ones. But I can't fully understand the whole picture of EFCPT.
2. I didn't drill down into how to unit test these changes, by EFCPT's own way.
3. The renaming of returned table column names lacks Edit UI supports. I'm not sure whether you are willing to add this feature or not.
4. I've changed many other files for local running/debugging. I believe these are not what you want.
5. I'm not familiar of how GitHub/PR works.

Hope these fixes helps EFCPT to support PostgreSQL `citext` type, easier to diagnose problem, and better renaming supports.


## 2026/4/20 2.6.1584 Update

In [Supports PostgreSQL's citext type in function #3402](https://github.com/ErikEJ/EFCorePowerTools/issues/3402)'s [response of ErikEJ](https://github.com/ErikEJ/EFCorePowerTools/issues/3402#issuecomment-4266276394), there is [latest daily build 2.6.1584](https://www.vsixgallery.com/extension/f4c4712c-ceae-4803-8e52-0e2049d5de9f).

I have tried it, but the result is still the same, with different build path.

### Problem 1: `citext` parameter in function

For [`Official_2_6_1584/efpt.testcitextin.config.json`](Official_2_6_1584/efpt.testcitextin.config.json):

```
System.Exception: System.ArgumentOutOfRangeException: cleanedTypeName: USER-DEFINED (Parameter 'storeType')
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.GetNpgsqlDbType(String storeType) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 192
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.GetClrType(String storeType, Boolean isNullable, String objectName, Boolean asParameter) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 101
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.ClrTypeFromNpgsqlParameter(ModuleParameter storedProcedureParameter, Boolean asMethodParameter) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 82
   at RevEng.Core.Routines.Extensions.PostgresClrTypeMapper.GetClrType(ModuleParameter parameter) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresClrTypeMapper.cs:line 10
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.<>c__DisplayClass16_0.<CreateUsings>b__4(ModuleParameter p) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 160
   at System.Linq.Enumerable.Any[TSource](IEnumerable`1 source, Func`2 predicate)
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.CreateUsings(ModuleScaffolderOptions scaffolderOptions, RoutineModel model, List`1 schemas) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 160
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.WriteDbContextInterface(ModuleScaffolderOptions scaffolderOptions, RoutineModel model, List`1 schemas) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 184
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.ScaffoldModel(RoutineModel model, ModuleScaffolderOptions scaffolderOptions, List`1 schemas, List`1& errors) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 97
   at RevEng.Core.ReverseEngineerScaffolder.GenerateStoredProcedures(ReverseEngineerCommandOptions options, List`1 schemas, List`1& errors, String outputContextDir, String modelNamespace, String contextNamespace, Boolean supportsProcedures) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\ReverseEngineerScaffolder.cs:line 221
   at RevEng.Core.ReverseEngineerRunner.GenerateFiles(ReverseEngineerCommandOptions options) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\ReverseEngineerRunner.cs:line 107
```

It only generate a single file: [`Official_2_6_1584/TestCitextInModels/PGContext.cs`](Official_2_6_1584/TestCitextInModels/PGContext.cs).

### Problem 2: `citext` return value in function

For [`Official_2_6_1584/efpt.testcitextout.config.json`](Official_2_6_1584/efpt.testcitextout.config.json):

```
System.Exception: System.ArgumentOutOfRangeException: storetype: citext, objectName: testcitextout (Parameter 'storeType')
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.GetClrType(String storeType, Boolean isNullable, String objectName, Boolean asParameter) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 165
   at RevEng.Core.Routines.Extensions.PostgresNpgsqlTypeExtensions.GetClrType(ModuleResultElement moduleResultElement) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresNpgsqlTypeExtensions.cs:line 96
   at RevEng.Core.Routines.Extensions.PostgresClrTypeMapper.GetClrType(ModuleResultElement resultElement) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Extensions\PostgresClrTypeMapper.cs:line 15
   at RevEng.Core.Routines.Scaffolder.<WriteResultClass>b__4_0(ModuleResultElement p) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Scaffolder.cs:line 41
   at System.Collections.Generic.List`1.FindIndex(Int32 startIndex, Int32 count, Predicate`1 match)
   at System.Collections.Generic.List`1.Exists(Predicate`1 match)
   at RevEng.Core.Routines.Scaffolder.WriteResultClass(List`1 resultElements, ModuleScaffolderOptions options, String name, String schemaName) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Scaffolder.cs:line 41
   at RevEng.Core.Routines.Procedures.ProcedureScaffolder.ScaffoldModel(RoutineModel model, ModuleScaffolderOptions scaffolderOptions, List`1 schemas, List`1& errors) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\Routines\Procedures\ProcedureScaffolder.cs:line 75
   at RevEng.Core.ReverseEngineerScaffolder.GenerateStoredProcedures(ReverseEngineerCommandOptions options, List`1 schemas, List`1& errors, String outputContextDir, String modelNamespace, String contextNamespace, Boolean supportsProcedures) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\ReverseEngineerScaffolder.cs:line 221
   at RevEng.Core.ReverseEngineerRunner.GenerateFiles(ReverseEngineerCommandOptions options) in C:\dev\GitHub\EFCorePowerTools\src\Core\RevEng.Core.80\ReverseEngineerRunner.cs:line 107
```

It only generate a single file: [`Official_2_6_1584/TestCitextOutModels/PGContext.cs`](Official_2_6_1584/TestCitextOutModels/PGContext.cs).

## Official_20260420

I found that the [latest daily build 2.6.1584](https://www.vsixgallery.com/extension/f4c4712c-ceae-4803-8e52-0e2049d5de9f)'s vsix, has an old `efreveng80.exe.zip` inside. The newest file in `efreveng80.exe.zip` is 2025/9/26, not the expected.

I've forked [ErikEJ/EFCorePowerTools](https://github.com/ErikEJ/EFCorePowerTools) from 2026/4/17 [Enable SQLite NodaTime support in EF Core 10 scaffolding paths (#3417)](https://github.com/ErikEJ/EFCorePowerTools/commit/178238bed4aa3cc5092ee28f28e6f7cdca239147) into my repo [ChrisTorng/EFCorePowerTools](https://github.com/ChrisTorng/EFCorePowerTools)'s [upstream_20260420](https://github.com/ChrisTorng/EFCorePowerTools/tree/upstream_20260420) branch.

After fix build problems:

1. Run `RevEng\efreveng80\BuildCmdlineTool.cmd` to generate `EFCorePowerTools\efreveng80.exe.zip`.
2. Delete `%TEMP%\efreveng8.2.6.0.1` folder.
3. Run `EFCorePowerTools`, it will recreate `%TEMP%\efreveng8.2.6.0.1` folder by unzipping `EFCorePowerTools\efreveng80.exe.zip` into it.

The results:
1. For [`Official_20260420/efpt.testcitextin.config.json`](Official_20260420/efpt.testcitextin.config.json): it generates [`Official_20260420/TestCitextInModels`](Official_2_6_1584/TestCitextInModels) successfully without error message.
2. For [`Official_20260420/efpt.testcitextout.config.json`](Official_20260420/efpt.testcitextout.config.json): it generates [`Official_20260420/TestCitextOutModels`](Official_2_6_1584/TestCitextOutModels) successfully without error message.  

But the code under [`Official_20260420/TestCitextOutModels`](Official_2_6_1584/TestCitextOutModels) has errors:

[`Official_20260420/IPGContextFunctions.cs`](Official_20260420/TestCitextOutModels/IPGContextFunctions.cs) L16 lacks first parameter:
```
Task<List<testcitextoutResult>> testcitextoutAsync(, CancellationToken cancellationToken = default);
```

[`Official_20260420/PGContextFunctions.cs`](Official_20260420/TestCitextOutModels/PGContextFunctions.cs) L46-54 lacks first parameter, and `npgsqlParameters` has [CS0826](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-messages/array-declaration-errors#invalid-element-type): `No best type found for implicitly-typed array` error:
```
public virtual async Task<List<testcitextoutResult>> testcitextoutAsync(, CancellationToken ancellationToken = default)
{
    var npgsqlParameters = new []
    {
    };
    var _ = await _context.SqlQueryAsync<testcitextoutResult>("SELECT * FROM \"dbo\"."testcitextout\" ()", npgsqlParameters, cancellationToken);

    return _;
}
```

## Official_20260420_Fix

In [Fix code generation without input parameter's case](https://github.com/ErikEJ/EFCorePowerTools/commit/c22fe2dcae1434637fd8257573d47be630761507) commit, after reapply fixes in [Fix citext in/out parameter code gen.](https://github.com/ErikEJ/EFCorePowerTools/commit/96a3ec6407b33766da612f1acba6aee945e8c5bf)'s [`RevEng.Core.80\Routines\PostgresRoutineModelFactory.cs](https://github.com/ErikEJ/EFCorePowerTools/commit/96a3ec6407b33766da612f1acba6aee945e8c5bf#diff-ac24f86d23f7321881c82ba1308e5656e795749d8ccbb903f4c6ce9332cc8cbf):
```
Sb.AppendLine("var npgsqlParameters = new []");
```
↓
```
Sb.AppendLine("var npgsqlParameters = new object[]");
```

```
line += useAsyncCalls ? $", CancellationToken{nullable} cancellationToken = default)" : ")";
```
↓
```
var hasParams = paramStrings.Any() || outParams.Count > 0;
line += useAsyncCalls
    ? $"{(hasParams ? ", " : string.Empty)}CancellationToken{nullable} cancellationToken = default)"
    : ")";
```

It generates [`Official_20260420_Fix/IPGContextFunctions.cs`](Official_20260420_Fix/TestCitextOutModels/IPGContextFunctions.cs)/[`Official_20260420_Fix/PGContextFunctions.cs`](Official_20260420_Fix/TestCitextOutModels/PGContextFunctions.cs) succesfully without error message. The code is correct too.