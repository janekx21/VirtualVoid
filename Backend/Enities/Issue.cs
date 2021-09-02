using System;
using System.ComponentModel.DataAnnotations;

namespace EventSourceDemo {
    public class Issue {
        public Issue(Guid id, string title) {
            this.id = id;
            this.title = title;
        }

        [Key] public Guid id { get; private set; }
        [Required] public string title { get; set; }
    }
}
