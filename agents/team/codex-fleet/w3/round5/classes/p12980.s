# n=5 model=out iset=I1 prefix14_class=12980
cmp P0, P1
mov S1, P0
cmovle S1, P1
cmovg P0, P1
mov P1, P3
cmp P2, P3
cmovle P3, P2
cmovle P2, P1
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmovg P3, S0
cmp S1, P2
cmovle P1, P2
