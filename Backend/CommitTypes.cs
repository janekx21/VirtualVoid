using System;
using System.Collections.Generic;

namespace EventSourceDemo {
    public static class CommitTypes {
        public record Change(string key, string value);

        public record Create(DateTime creation, string initial);
    }
}
