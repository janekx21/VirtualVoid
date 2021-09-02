using System;
using System.ComponentModel.DataAnnotations;

namespace EventSourceDemo {
    public class Issue {

        [Key] public Guid id { get; set; } = Guid.NewGuid();
        [Required] public string title { get; set; } = null!;
        [Required] public string description { get; set; } = null!;
        [Required] public State state { get; set; } = null!;
    }
}
