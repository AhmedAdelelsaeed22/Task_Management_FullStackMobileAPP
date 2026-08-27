using System;
using System.Collections.Generic;
using DataAccessLayer.Entities;
using Microsoft.EntityFrameworkCore;

namespace DataAccessLayer.Data;

public partial class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<refresh_token> refresh_tokens { get; set; }

    public virtual DbSet<task> tasks { get; set; }

    public virtual DbSet<task_priority> task_priorities { get; set; }

    public virtual DbSet<task_status> task_statuses { get; set; }

    public virtual DbSet<user> users { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<refresh_token>(entity =>
        {
            entity.HasKey(e => e.refresh_token_id).HasName("pk_refresh_tokens");

            entity.ToTable("refresh_tokens", "identity");

            entity.Property(e => e.refresh_token_id).UseIdentityAlwaysColumn();

            entity.HasOne(d => d.user).WithMany(p => p.refresh_tokens)
                .HasForeignKey(d => d.user_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_refresh_tokens_users");
        });

        modelBuilder.Entity<task>(entity =>
        {
            entity.HasKey(e => e.task_id).HasName("tasks_pkey");

            entity.ToTable("tasks", "task");

            entity.Property(e => e.task_id).UseIdentityAlwaysColumn();
            entity.Property(e => e.creation_date).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.estimate_hours).HasPrecision(6, 2);
            entity.Property(e => e.last_update_date).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.title).HasMaxLength(200);

            entity.HasOne(d => d.priority).WithMany(p => p.tasks)
                .HasForeignKey(d => d.priority_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_tasks_priority");

            entity.HasOne(d => d.status).WithMany(p => p.tasks)
                .HasForeignKey(d => d.status_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_tasks_status");

            entity.HasOne(d => d.user).WithMany(p => p.tasks)
                .HasForeignKey(d => d.user_id)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("fk_tasks_user");
        });

        modelBuilder.Entity<task_priority>(entity =>
        {
            entity.HasKey(e => e.priority_id).HasName("task_priority_pkey");

            entity.ToTable("task_priority", "task");

            entity.Property(e => e.priority_id).UseIdentityAlwaysColumn();
            entity.Property(e => e.priority_level).HasMaxLength(30);
        });

        modelBuilder.Entity<task_status>(entity =>
        {
            entity.HasKey(e => e.task_status_id).HasName("task_status_pkey");

            entity.ToTable("task_status", "task");

            entity.HasIndex(e => e.status_name, "task_status_status_name_key").IsUnique();

            entity.Property(e => e.task_status_id).UseIdentityAlwaysColumn();
            entity.Property(e => e.status_name).HasMaxLength(50);
        });

        modelBuilder.Entity<user>(entity =>
        {
            entity.HasKey(e => e.user_id).HasName("users_pkey");

            entity.ToTable("users", "identity");

            entity.HasIndex(e => e.email_address, "ix_email_address").HasMethod("hash");

            entity.HasIndex(e => e.email_address, "users_email_address_key").IsUnique();

            entity.HasIndex(e => e.user_name, "users_user_name_key").IsUnique();

            entity.Property(e => e.user_id).UseIdentityAlwaysColumn();
            entity.Property(e => e.account_status)
                .HasMaxLength(20)
                .HasDefaultValueSql("'Active'::character varying");
            entity.Property(e => e.date_created).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.email_address).HasMaxLength(100);
            entity.Property(e => e.full_name).HasMaxLength(100);
            entity.Property(e => e.job_title).HasMaxLength(100);
            entity.Property(e => e.last_login_date).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.time_zone).HasMaxLength(100);
            entity.Property(e => e.user_name).HasMaxLength(50);
            entity.Property(e => e.user_role)
                .HasMaxLength(200)
                .HasDefaultValueSql("'user'::character varying");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
