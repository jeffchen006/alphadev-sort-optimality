# n=5 model=out iset=I1 prefix14_class=13695
mov S1, P2
cmp P2, P0
mov S0, P1
cmovle S1, P0
cmovg P2, P0
cmp P1, P3
cmovg S0, P3
cmovle P1, P3
cmp S0, P2
mov S2, S1
cmovge P3, S0
cmovg S0, P2
cmovg P2, P3
cmp P1, S2
