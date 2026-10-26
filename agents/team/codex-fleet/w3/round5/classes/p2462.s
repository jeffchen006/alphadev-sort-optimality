# n=5 model=out iset=I1 prefix14_class=2462
cmp P0, P2
cmovge S2, P0
cmovl S2, P2
cmovg P0, P2
cmp P1, P3
mov P2, P3
cmovge P3, P1
cmovge P1, P2
mov P2, P3
cmp P3, S2
cmovl P2, S2
cmovle S2, P3
cmp P1, P0
cmovle S0, P0
