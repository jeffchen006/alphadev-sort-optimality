# n=5 model=out iset=I1 prefix14_class=227
cmp P0, P2
mov S2, P0
cmovle S2, P2
cmovle P2, P0
mov S0, P1
cmp P1, P3
cmovg P1, P3
cmovge P3, S0
cmp P1, P2
cmovge P0, P1
cmovle P0, P2
cmovle P2, P1
cmp P3, S2
cmovle S0, S2
