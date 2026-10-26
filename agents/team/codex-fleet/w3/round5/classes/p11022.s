# n=5 model=out iset=I1 prefix14_class=11022
cmp P1, P3
mov S0, P2
cmovge S2, P3
cmovg P3, P1
cmovge P1, S2
cmp P0, S0
cmovg P2, P0
cmovle S0, P0
cmp P2, P3
cmovle P0, P2
cmovle P2, P3
cmovle P3, P0
cmp P1, S0
cmovle P0, S0
