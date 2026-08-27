using System;
using System.Collections.Generic;

namespace DataAccessLayer.Entities;

public partial class task
{
    public int task_id { get; set; }

    public int user_id { get; set; }

    public int status_id { get; set; }

    public int priority_id { get; set; }

    public string title { get; set; } = null!;

    public string? description { get; set; }

    public decimal? estimate_hours { get; set; }

    public DateTime creation_date { get; set; }

    public DateTime last_update_date { get; set; }

    public DateTime? completion_date { get; set; }

    public virtual task_priority priority { get; set; } = null!;

    public virtual task_status status { get; set; } = null!;

    public virtual user user { get; set; } = null!;
}
