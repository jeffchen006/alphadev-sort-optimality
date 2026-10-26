# n=5 model=out iset=I1 prefix14_class=228
cmp P0, P2
mov S0, P1
mov S2, P0
cmovle S2, P2
cmovle P2, P0
cmp P1, P3
cmovg P1, P3
cmovge P3, S0
cmp P1, P2
mov P0, P1
cmovle P0, P2
cmovle P2, P1
cmp P3, S2
cmovg S0, P3
