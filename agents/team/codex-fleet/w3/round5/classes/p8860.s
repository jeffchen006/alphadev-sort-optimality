# n=5 model=out iset=I1 prefix14_class=8860
mov S0, P2
cmp P0, P2
cmovle S0, P0
cmovge P2, P0
cmp P1, P3
cmovge P0, P3
cmovge P3, P1
cmovg P1, P0
mov S2, P2
cmp P3, P2
cmovge P2, P3
cmovge P3, S2
cmovl S2, P3
mov S1, S0
