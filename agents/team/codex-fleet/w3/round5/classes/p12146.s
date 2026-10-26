# n=5 model=out iset=I1 prefix14_class=12146
cmp P0, P1
mov S0, P1
cmovle S0, P0
cmovg P1, P0
cmp P3, P2
cmovge S2, P2
mov P0, S0
cmovge P2, P3
cmovge P3, S2
cmp P0, P3
cmovg P0, P3
cmovg P3, S0
mov P0, P2
mov S0, P3
