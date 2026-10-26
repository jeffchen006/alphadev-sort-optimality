# n=5 model=out iset=I1 prefix14_class=3786
cmp P3, P1
mov S0, P3
cmovg P3, P1
cmovg P1, S0
cmp P2, P0
cmovg S0, P2
cmovle S0, P0
mov S2, P3
cmovge P2, P0
cmp S2, P2
cmovle P3, P2
cmovle P2, S2
cmp P1, S0
cmovge P0, S0
