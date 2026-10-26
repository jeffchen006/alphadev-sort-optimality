# n=5 model=out iset=I1 prefix14_class=631
mov S2, P1
cmp P3, P0
mov S1, P3
cmovge P3, P0
cmovle S1, P0
cmp P1, P2
cmovge P1, P2
cmovg P2, S2
cmp P2, S1
mov S2, P2
cmovl S2, S1
cmovle S1, P2
mov S0, P3
mov P0, S1
