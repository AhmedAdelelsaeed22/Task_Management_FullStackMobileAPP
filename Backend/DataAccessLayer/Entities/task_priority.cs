using System;
using System.Collections.Generic;

namespace DataAccessLayer.Entities;

public partial class task_priority
{
    public int priority_id { get; set; }

    public string priority_level { get; set; } = null!;

    public virtual ICollection<task> tasks { get; set; } = new List<task>();
}
