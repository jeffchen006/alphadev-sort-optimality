# n=5 model=out iset=I1 prefix14_class=12755
cmp P3, P0
cmovge S0, P0
cmovg P0, P3
cmovge P3, S0
mov S1, P3
cmp P1, P2
mov S2, P1
cmovle S2, P2
cmovle P2, P1
cmp P2, P3
cmovg S1, P2
cmovge P2, P3
mov P2, S2
cmp S2, P0
