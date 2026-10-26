# n=5 model=out iset=I1 prefix14_class=520
cmp P0, P1
cmovl S1, P0
cmovge S1, P1
cmovg P1, P0
cmp P2, P3
mov S2, P2
cmovge P2, P3
mov P0, P1
cmovge P3, S2
mov S2, S1
cmp P2, S2
cmovge S2, P2
cmovle S1, P2
mov P2, S2
