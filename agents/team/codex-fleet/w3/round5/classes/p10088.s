# n=5 model=out iset=I1 prefix14_class=10088
mov S0, P2
cmp P3, P2
mov S2, P0
cmovle P2, P3
cmovg S0, P3
cmp P0, P1
cmovge P0, P1
cmovle S2, P1
cmp S0, S2
cmovle P3, S0
cmovle S0, S2
cmovle S2, P3
mov S0, P2
cmp P2, P0
