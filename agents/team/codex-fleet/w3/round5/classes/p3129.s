# n=5 model=out iset=I1 prefix14_class=3129
cmp P0, P3
mov S0, P3
cmovle S0, P0
cmovge P3, P0
mov S2, P1
cmp P2, P1
cmovle P1, P2
cmovg S2, P2
mov P0, P1
cmp P1, S0
cmovle P1, S0
cmovg P0, S0
cmp P3, S2
cmovge P0, S2
