# n=5 model=out iset=I1 prefix14_class=2749
mov S1, P1
cmp P1, P0
cmovge P1, P0
cmovle S1, P0
mov P0, P3
cmp P0, P2
cmovge P0, P2
cmovle P3, P2
mov S0, P3
cmp S1, S0
cmovle P3, S1
cmovle S1, S0
cmp P0, P1
cmovle S2, P0
