# n=5 model=out iset=I1 prefix14_class=7767
mov S0, P3
cmp S0, P1
cmovle P3, P1
cmovg S0, P1
cmp P0, P2
cmovge P1, P0
cmovg P0, P2
cmovle P1, P2
cmp P0, S0
mov S1, P0
cmovge P0, S0
cmovle S1, S0
mov S2, P3
mov P0, S1
