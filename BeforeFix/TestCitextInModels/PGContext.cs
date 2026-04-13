using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace PostgreSqlCitext.BeforeFix.TestCitextInModels;

public partial class PGContext : DbContext
{
    public PGContext(DbContextOptions<PGContext> options)
        : base(options)
    {
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasPostgresExtension("dbo", "citext");

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
