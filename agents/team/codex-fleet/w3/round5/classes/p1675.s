# n=5 model=out iset=I1 prefix14_class=1675
cmp P2, P3
cmovle S2, P2
cmovge S2, P3
cmovle P2, P3
mov S0, P0
cmp S0, P1
cmovge P0, P1
cmovg P1, S0
cmp S2, P0
mov S0, P0
cmovg S0, S2
mov S1, P2
cmovg S2, P0
mov P0, S0
