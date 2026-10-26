# n=5 model=out iset=I1 prefix14_class=10105
mov S2, P1
mov S0, P2
cmp P3, P2
cmovg S0, P3
cmovge P3, P2
cmp S2, P0
cmovge P1, P0
cmovge P0, S2
cmp S0, P0
cmovle S2, S0
mov P2, P1
cmovle S0, P0
cmovle P0, S2
cmp P3, P2
