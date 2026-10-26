# n=5 model=out iset=I1 prefix14_class=11317
cmp P2, P1
cmovle S2, P2
cmovl P2, P1
cmovge S2, P1
cmp P0, P3
mov P1, P0
cmovge P0, P3
cmovge P3, P1
cmp P2, P3
cmovge S0, P2
cmovge P2, P3
mov P1, S2
cmovg P3, S0
cmp S2, P0
