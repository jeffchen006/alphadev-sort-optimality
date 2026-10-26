From Stdlib Require Import List.
From CmovSort Require Import Machine Vec Good Prune Check Sound Inst Sort3.
Time Eval vm_compute in length (search 3 9 reps3 tg3 strict3 6).
Time Eval vm_compute in all_okb 3 9 reps3 tg3 strict3 (search 3 9 reps3 tg3 strict3 6) 6.
Time Eval vm_compute in length (search 3 10 reps3 tg3 strict3 7).
Time Eval vm_compute in all_okb 3 10 reps3 tg3 strict3 (search 3 10 reps3 tg3 strict3 7) 7.
