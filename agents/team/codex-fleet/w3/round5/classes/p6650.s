# n=5 model=out iset=I1 prefix14_class=6650
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
mov S2, P3
cmovge P1, S0
cmp P2, S2
cmovg P3, P2
cmovg P2, S2
cmp P3, P0
mov S0, P3
cmovg P3, P0
cmovle S0, P0
cmp P1, P2
cmovle S2, P2
