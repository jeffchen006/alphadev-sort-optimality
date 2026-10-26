# n=5 model=out iset=I1 prefix14_class=6826
mov S0, P1
cmp P2, P3
mov S2, P3
cmovle S2, P2
cmovle P2, P3
cmp P1, P0
cmovg S0, P0
cmovle P1, P0
mov P3, P2
cmp P1, P2
cmovle P2, P1
cmovle P1, P3
cmp S2, S0
cmovge P1, S2
