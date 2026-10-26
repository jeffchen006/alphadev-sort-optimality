# n=5 model=out iset=I1 prefix14_class=2842
cmp P3, P0
mov S1, P0
mov S0, P2
cmovle S1, P3
cmovl P3, P0
mov P0, P3
cmp S0, P1
cmovg P2, P1
cmovg P1, S0
cmp P1, P0
cmovl P3, P1
cmovl P1, P0
cmp P2, S1
mov P1, P3
