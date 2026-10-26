# n=5 model=out iset=I1 prefix14_class=2725
cmp P2, P0
mov S1, P2
cmovg P2, P0
cmovl S1, P0
cmp P3, P1
mov S0, P1
cmovle S0, P3
cmovl P3, P1
cmovg P1, P3
cmp S1, P1
cmovge P1, S1
cmovl P3, S1
mov P1, S0
cmp P1, P2
