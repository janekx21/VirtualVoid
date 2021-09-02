using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace EventSourceDemo {
    public class Board {
        [Key] public Guid id { get; set; } = Guid.NewGuid();
        [Required] public string name { get; set; } = null!;

        [Required] public IEnumerable<Issue> issues { get; set; } = Enumerable.Empty<Issue>();
        [Required] public IEnumerable<State> states { get; set; } = Enumerable.Empty<State>();
    }
}
