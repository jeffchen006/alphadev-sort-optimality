# n=5 model=out iset=I1 prefix14_class=8011
mov S1, P0
cmp P3, P0
cmovge P0, P3
cmovge P3, S1
cmp P2, P1
mov S0, P0
cmovle S1, P1
cmovle P1, P2
mov S2, P3
cmovle P2, S1
cmp P1, P3
cmovg S2, P1
cmovle P3, P1
cmovle P1, S2
