# n=5 model=out iset=I1 prefix14_class=2726
mov S0, P2
cmp P2, P0
cmovg P2, P0
cmovl S0, P0
cmp P3, P1
cmovg S1, P1
cmovle S1, P3
cmovl P3, P1
cmovg P1, P3
cmp S0, P1
cmovg P1, S0
cmovl P3, S0
cmp S1, P2
cmovge P1, S1
