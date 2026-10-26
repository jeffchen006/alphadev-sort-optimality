# n=5 model=out iset=I1 prefix14_class=6901
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
mov S1, P3
cmp S1, P1
cmovl P3, P1
cmovge S1, P1
cmp P0, P3
cmovle S0, P0
cmovg S0, P3
cmovg P3, P0
cmp S1, P2
cmovge P0, P2
