# n=5 model=out iset=I1 prefix14_class=2729
cmp P3, P0
cmovle S0, P0
cmovg S0, P3
cmovg P3, P0
cmp P2, P1
cmovg S1, P1
cmovle S1, P2
cmovl P2, P1
mov P1, S0
cmp P2, P1
cmovg S0, P2
cmovl P1, P2
cmp S1, P3
cmovle S0, P3
