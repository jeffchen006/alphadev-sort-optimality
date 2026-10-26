# n=5 model=out iset=I1 prefix14_class=9944
cmp P2, P3
mov S0, P2
cmovle S0, P3
cmovl P3, P2
cmp P1, P0
cmovge P2, P1
cmovge P1, P0
mov S1, S0
cmovge P0, P2
cmp S1, P0
cmovge S0, P0
cmovl S1, P0
mov S1, P1
cmp S1, P3
