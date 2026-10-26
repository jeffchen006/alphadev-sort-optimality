# n=5 model=out iset=I1 prefix14_class=11058
cmp P2, P1
mov S0, P1
cmovle S0, P2
cmovg P1, P2
mov S2, P3
cmp S2, P0
cmovge P3, P0
cmovge P0, S2
cmp P1, P0
cmovge P2, P1
cmovge P1, P0
cmovle P2, P0
cmp P3, S0
cmovge S2, S0
