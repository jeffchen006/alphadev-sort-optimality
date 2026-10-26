# n=5 model=out iset=I1 prefix14_class=3842
mov S0, P2
cmp S0, P0
cmovge P2, P0
cmovge P0, S0
cmp P1, P3
mov S0, P1
cmovle S0, P3
cmovl P3, P1
cmp P2, P3
cmovl S2, P2
cmovl P2, P3
cmovl P3, S2
cmp P0, S0
cmovl S2, S0
