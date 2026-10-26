# n=5 model=out iset=I1 prefix14_class=9688
cmp P0, P3
mov S0, P3
cmovg P3, P0
cmovle S0, P0
mov S2, P2
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
mov S1, S2
cmp P1, P3
cmovge P2, P1
cmovg P1, P3
cmovg P3, P2
cmp S0, S1
