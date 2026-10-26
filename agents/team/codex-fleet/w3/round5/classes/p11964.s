# n=5 model=out iset=I1 prefix14_class=11964
mov S2, P1
cmp P0, P1
cmovle P1, P0
cmovge S2, P0
cmp P2, P3
mov S1, S2
cmovge P0, P2
cmovg P2, P3
cmovg P3, P0
cmp S2, P3
mov S0, P2
cmovle S2, P3
cmovg S1, P3
cmp P2, P1
