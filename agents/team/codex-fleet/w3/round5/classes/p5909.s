# n=5 model=out iset=I1 prefix14_class=5909
cmp P3, P1
mov S0, P3
cmovle S0, P1
mov S2, P2
cmovge P3, P1
cmp P0, P2
cmovg S2, P0
cmovge P0, P2
cmp S2, S0
mov P1, P0
cmovle P2, S2
cmovle S2, S0
cmovle S0, P2
mov S1, S0
