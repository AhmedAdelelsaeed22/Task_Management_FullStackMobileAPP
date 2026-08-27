using System;
using System.Collections.Generic;

namespace DataAccessLayer.Entities;

public partial class task_status
{
    public int task_status_id { get; set; }

    public string status_name { get; set; } = null!;

    public virtual ICollection<task> tasks { get; set; } = new List<task>();
}
