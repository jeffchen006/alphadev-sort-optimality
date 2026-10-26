# n=5 model=out iset=I1 prefix14_class=4872
cmp P1, P0
cmovg S0, P0
cmovle S0, P1
cmovge P0, P1
cmp P3, P2
mov S2, P2
cmovle P2, P3
cmovge S2, P3
cmp P2, S0
cmovg S1, P2
cmovge P2, S0
cmovle S1, S0
mov P2, P0
cmp S2, P2
