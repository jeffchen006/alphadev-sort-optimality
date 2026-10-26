# n=5 model=out iset=I1 prefix14_class=11461
mov S0, P0
cmp S0, P2
cmovle S0, P2
cmovg P0, P2
mov P2, P3
cmp P1, P3
cmovl P3, P1
cmovge P2, P1
mov P1, P0
cmp P3, P0
cmovl P1, P3
cmovge P0, P3
cmp S0, P2
cmovge P3, P2
