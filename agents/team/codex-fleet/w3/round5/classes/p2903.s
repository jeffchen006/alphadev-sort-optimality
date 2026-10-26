# n=5 model=out iset=I1 prefix14_class=2903
mov S2, P1
cmp P1, P0
cmovg S2, P0
cmovl P1, P0
mov P0, P3
cmp P2, P3
cmovg P0, P2
cmovg P2, P3
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
mov S0, S2
cmovle P1, S1
cmp S2, P2
