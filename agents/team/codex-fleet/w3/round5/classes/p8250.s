# n=5 model=out iset=I1 prefix14_class=8250
cmp P1, P2
mov S2, P2
cmovle P2, P1
mov S0, P3
cmovle P1, S2
mov S1, P2
cmp P0, P3
cmovg P3, P0
cmovge P0, S0
cmp S1, P0
cmovge P2, P0
cmovle S1, P0
cmp P3, P1
cmovle S0, P1
