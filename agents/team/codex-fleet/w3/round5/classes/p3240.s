# n=5 model=out iset=I1 prefix14_class=3240
cmp P2, P3
cmovge S0, P2
cmovle S0, P3
cmovge P2, P3
cmp P0, P1
mov P3, P1
cmovg P3, P0
cmovg P0, P1
mov P1, P2
cmp P2, P0
cmovle P1, P0
cmovg P2, P0
mov P0, P3
cmp S0, P3
