# n=5 model=out iset=I1 prefix14_class=9804
mov S0, P1
mov S2, P3
cmp S2, P2
cmovle P3, P2
cmovg S2, P2
cmp P1, P0
cmovle P1, P0
cmovge S0, P0
cmp P1, P3
cmovle S1, P1
cmovg S1, P3
cmovg P3, P1
cmp S2, S0
cmovle P2, S2
