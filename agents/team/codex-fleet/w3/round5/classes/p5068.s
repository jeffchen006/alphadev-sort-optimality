# n=5 model=out iset=I1 prefix14_class=5068
mov S0, P3
cmp S0, P1
cmovl S0, P1
cmovl P1, P3
mov P3, P0
mov S1, P1
cmp P2, P3
cmovge P0, P2
cmovl P3, P2
cmp S1, P3
cmovge P1, P3
mov P1, P0
cmovle S1, P3
cmp P0, S0
