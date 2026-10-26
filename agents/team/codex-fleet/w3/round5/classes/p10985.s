# n=5 model=out iset=I1 prefix14_class=10985
mov S1, P2
cmp S1, P0
cmovg S1, P0
mov S2, P3
cmovg P0, P2
cmp P3, P1
cmovl P3, P1
cmovl P1, S2
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
cmovl P0, S2
cmp S1, P1
cmovle S2, P1
