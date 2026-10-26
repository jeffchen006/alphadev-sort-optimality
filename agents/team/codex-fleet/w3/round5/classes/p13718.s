# n=5 model=out iset=I1 prefix14_class=13718
mov S2, P1
cmp P3, P2
cmovge S1, P3
cmovle S1, P2
cmovg P3, P2
cmp S2, P0
cmovge S2, P0
cmovle P1, P0
cmp P1, S1
cmovg P0, P1
cmovge P1, S1
cmovg S1, P0
mov S0, P3
cmp S0, S2
