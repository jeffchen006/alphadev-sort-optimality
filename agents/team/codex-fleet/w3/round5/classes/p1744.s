# n=5 model=out iset=I1 prefix14_class=1744
mov S1, P0
cmp S1, P1
cmovl S1, P1
cmovl P1, P0
mov S0, P2
cmp S0, P3
cmovge S0, P3
cmovl P2, P3
mov P0, P2
mov P3, S0
cmp S0, P1
cmovle S0, P1
cmovge P3, P1
cmovg P1, S0
