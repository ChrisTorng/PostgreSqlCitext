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

## Problem 1: `citext` parameter in function

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

## Problem 2: `citext` return value in function

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

## Problem 3: Generate stops without showing which item causes the problem

For both cases, the generate stops, without anything like [`sql/testtext.sql`](sql/testtext.sql) related generated. You can check [`BeforeFix/TestCitextInModels/`](BeforeFix/TestCitextInModels/) and [`BeforeFix/TestCitextOutModels/`](BeforeFix/TestCitextOutModels/) folders for generated codes.

For [`sql/testcitextin.sql`](sql/testcitextin.sql) one, the error message doesn't shows which item causes this problem, makes it hard to find out the problematic item while there are lots of items.

But for [`sql/\testtext.sql`](sql/testtext.sql) with [`BeforeFix/efpt.testtext.config.json`](BeforeFix/efpt.testtext.config.json), it generates codes in [`BeforeFix/TestTextModels/`](BeforeFix/TestTextModels/) successfully.

## Problem 4: The renaming of returned table column doesn't work

The Edit UI can only rename the function name `testtext` into `TestText`, not supporting the returned table. Even with manual editing of [`BeforeFix/efpt.testtext.config.json`](efpt.testtext.config.json) (it's easy now with the help of AI) to rename the returned table column, it doesn't work. You can check the generated code in [`BeforeFix/TestTextModels/TestTextResult.cs`](TestTextModels/TestTextResult.cs). And the manual editing of [`BeforeFix/efpt.testtext.config.json`] will be overridden by later Edit UI.
