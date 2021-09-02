using System;
using System.ComponentModel.DataAnnotations;

namespace EventSourceDemo {
    public class State {
        [Key] public Guid id { get; set; } = Guid.NewGuid();
        [Required] public string name { get; set; } = null!;
    }
}
