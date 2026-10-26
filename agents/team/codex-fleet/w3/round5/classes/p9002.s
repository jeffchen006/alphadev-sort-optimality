# n=5 model=out iset=I1 prefix14_class=9002
mov S1, P0
mov S2, P1
cmp P3, S2
cmovg S2, P3
cmovge P3, P1
cmp P2, P0
cmovle S1, P2
cmovle P2, P0
cmp S2, P2
cmovge S0, P2
cmovg P2, S2
cmovg S2, S0
mov P2, S2
mov P1, S1
